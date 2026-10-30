# frozen_string_literal: true

require 'json'
require 'cgi'

module Mess
  # Les pages sont créées en mémoire; aucun Markdown n'est copié dans site/.
  class Documents < Jekyll::Generator
    safe false
    priority :highest

    def read_source(root, relative)
      path = File.expand_path(relative, root)
      raise "Source hors de textes/ : #{relative}" unless path.start_with?(File.join(root, 'textes') + File::SEPARATOR)
      File.read(path, encoding: 'bom|utf-8')
    end

    def key(line)
      if (heading = line.match(/\A(#+)\s+(.+)/))
        number = heading[2].match(/\A(\d+)\./)
        'H:' + (number ? number[1] : heading[2])
      elsif (paragraph = line.match(/\A(\d+\.\d+)\.\s/))
        'P:' + paragraph[1]
      else
        'T:' + line
      end
    end

    def root_anchor(spec)
      case spec['id']
      when 'statuts' then 'partie-1'
      when /\Ar([1-6])\z/ then "reglement-#{Regexp.last_match(1)}"
      when /\Aannexe-/ then spec['id']
      end
    end

    def blocks(content, spec = nil)
      sequence = {}
      content.lines.filter_map do |raw|
        line = raw.strip
        next if line.empty?
        if spec && (number = line.match(/\A(\d+)\.(\d+)\.\s/))
          article, paragraph = number.captures.map(&:to_i)
          raise "Numérotation discontinue dans #{spec['source']} : #{number[0]}" unless paragraph == sequence.fetch(article, 0) + 1
          sequence[article] = paragraph
        end
        ids = spec ? Array(spec['anchors'][key(line)]).dup : []
        ids << root_anchor(spec) if spec && line == spec['marker']
        ids << 'partie-2' if line == '## Partie II — Règlements'
        { 'text' => line, 'ids' => ids.compact.uniq }
      end
    end

    def render(items, page_id, owners, baseurl, separate: false)
      items.each_with_index.map do |block, index|
        line = block['text']
        if separate
          line = line.gsub(/\[([^\]]+)\]\((#[^)]+)\)/) do
            label, href = Regexp.last_match.captures
            owner = owners.fetch(href.delete_prefix('#'))
            target = owner == page_id ? href : "#{baseurl}/#{owner}.html#{href}"
            "[#{label}](#{target})"
          end
        end
        line += " {#titre-#{page_id}-#{index}}" if line.start_with?('#')
        anchors = block['ids'].map { |id| %(<a id="#{CGI.escapeHTML(id)}"></a>\n) }
        (anchors + [line]).join("\n")
      end.join("\n\n") + "\n"
    end

    def page(site, id, title, content, extra = {})
      item = Jekyll::PageWithoutAFile.new(site, site.source, '', "#{id}.md")
      item.content = content
      item.data.merge!({ 'layout' => 'default', 'title' => title,
                         'document_label' => title, 'permalink' => "/#{id}.html" }.merge(extra))
      site.pages << item
    end

    def legacy_destination(path)
      name = File.basename(path, '.md')
      return 'partie-1' if name == 'constitution-consolidee'
      return "reglement-#{Regexp.last_match(1)}" if name =~ /\AR([1-6])-proposition\z/
      { 'annexe-f' => 'annexe-e', 'annexe-g' => 'annexe-f-regisseur',
        'annexe-h' => 'annexe-g-serveur' }.fetch(name, name)
    end

    def generate(site)
      root = site.source
      structure = JSON.parse(read_source(root, 'textes/structure.json'))
      specs = structure.fetch('segments')
      contents = structure.fetch('assemblage').filter_map { |item| item['source'] }.to_h do |path|
        [path, read_source(root, path)]
      end
      documents = specs.map do |spec|
        content = contents.fetch(spec['source'])
        raise "Titre manquant dans #{spec['source']}" unless content.lines.first.strip == spec['marker']
        [spec, blocks(content, spec)]
      end
      owners = {}
      documents.each do |spec, items|
        items.each do |block|
          block['ids'].each do |id|
            raise "Ancre répétée : #{id}" if owners.key?(id)
            owners[id] = spec['id']
          end
        end
      end
      documents.each do |spec, items|
        items.each do |block|
          block['text'].scan(/\[[^\]]+\]\(#([^)]+)\)/).flatten.each do |id|
            raise "Renvoi sans destination dans #{spec['source']} : #{id}" unless owners.key?(id)
          end
        end
      end
      # Le reste du dépôt reste visible au surveillant local, sans être publié.
      site.pages.select! { |item| item.path == 'site/index.md' || item.path.start_with?('site/assets/') }
      site.static_files.select! { |item| item.relative_path.delete_prefix('/').start_with?('site/assets/') || item.relative_path.delete_prefix('/') == 'site/CNAME' }
      site.static_files.map! { |item| Asset.new(site, item.path, item.relative_path.delete_prefix('/').delete_prefix('site/')) }
      site.data['documents'] = specs.map { |spec| { 'id' => spec['id'], 'titre' => spec['titre'], 'url' => spec['url'] } }
      version = contents.fetch('textes/presentation.md').lines.find { |line| line.start_with?('Version ') }.to_s.strip
      documents.each do |spec, items|
        headings = items.drop(1).filter_map { |block| block['text'][/\A(#+) /, 1]&.length }
        shift = headings.min.to_i - 2
        body = items.drop(1).map do |block|
          line = block['text'].sub(/\A(#+) /) { '#' * [1, Regexp.last_match(1).length - shift].max + ' ' }
          { 'text' => line, 'ids' => block['ids'] }
        end
        body.unshift({ 'text' => version, 'ids' => [] })
        body.unshift({ 'text' => '# ' + spec['titre'], 'ids' => items.first['ids'] })
        page(site, spec['id'], spec['titre'], render(body, spec['id'], owners, site.baseurl, separate: true))
      end
      by_source = documents.to_h { |spec, items| [spec['source'], items] }
      collection = structure['assemblage'].flat_map do |item|
        item['source'] ? by_source.fetch(item['source']) { blocks(contents.fetch(item['source'])) } : blocks(item['texte'])
      end
      page(site, 'recueil', 'Statuts et règlements — Recueil complet', render(collection, 'recueil', owners, site.baseurl))
      annexes = specs.select { |spec| spec['id'].start_with?('annexe-') }.map do |spec|
        "- [#{spec['titre']}](#{site.baseurl}#{spec['url']})"
      end.join("\n")
      page(site, 'annexes', 'Annexes des responsabilités', "# Annexes des responsabilités\n\n#{annexes}\n")
      original = read_source(root, 'textes/archives/constitution.md').sub(/\A---\r?\n.*?\r?\n---\r?\n/m, '')
      page(site, 'constitution', 'Constitution originale transcrite', original)
      site.data.fetch('redirections', {}).each_key do |path|
        page(site, path.delete_suffix('.md'), 'Ancien lien du projet', '',
             'layout' => 'redirection', 'destination' => legacy_destination(path))
      end
      page(site, 'reglements', 'Règlements', '', 'layout' => 'redirection', 'destination' => 'reglement-1')
      profile = JSON.parse(File.read(File.join(root, 'generateur/modeles/9eg.json'), encoding: 'utf-8'))
      logo = File.expand_path(profile.fetch('insigne'), root)
      raise "Logo absent : #{logo}" unless File.file?(logo)
      site.static_files << Asset.new(site, logo, 'assets/images/logo-9eg.png')
    end
  end

  class Asset < Jekyll::StaticFile
    def initialize(site, original, output)
      super(site, File.dirname(original), '', File.basename(original))
      @output = output
    end

    def destination(dest)
      File.join(dest, @output)
    end
  end
end
