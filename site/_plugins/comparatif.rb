# frozen_string_literal: true

require 'json'
require 'cgi'

module Mess
  # La comparaison utilise les mêmes annotations que le PDF, sans dépendre de Python.
  # Elle est créée après le générateur principal, qui filtre les pages publiées.
  class Comparatif < Jekyll::Generator
    safe false
    priority :low

    FILES = {
      'S' => 'statuts', 'AP' => 'avant-propos',
      'R1' => 'r1', 'R2' => 'r2', 'R3' => 'r3', 'R4' => 'r4',
      'A' => 'annexe-a', 'B' => 'annexe-b', 'C' => 'annexe-c',
      'D' => 'annexe-d', 'E' => 'annexe-e',
      'F' => 'annexe-f-regisseur', 'G' => 'annexe-g-serveur'
    }.freeze
    LABELS = {
      'S' => 'Statuts', 'AP' => 'Avant-propos',
      'R1' => 'R1', 'R2' => 'R2', 'R3' => 'R3', 'R4' => 'R4',
      'A' => 'Annexe A', 'B' => 'Annexe B', 'C' => 'Annexe C',
      'D' => 'Annexe D', 'E' => 'Annexe E', 'F' => 'Annexe F', 'G' => 'Annexe G'
    }.freeze
    PDF = 'assets/documents/constitution-initiale-annotee-0.13.pdf'

    def annotation(notes, label, baseurl, sources)
      paragraphs = notes.map do |text|
        # Échapper le texte avant de transformer seulement les renvois déclarés.
        escaped = CGI.escapeHTML(text).gsub(/\[\[([A-Z0-9]+):(\d+(?:\.\d+)+)\]\]/) do
          group, number = Regexp.last_match.captures
          filename = FILES.fetch(group)
          unless sources.fetch(group).match?(/^#{Regexp.escape(number)}\. /)
            raise "Renvoi du comparatif sans destination : #{group}:#{number}"
          end
          anchor = "#{filename}-paragraphe-#{number.tr('.', '-')}"
          href = "#{baseurl}/#{filename}.html##{anchor}"
          %(<a href="#{CGI.escapeHTML(href)}">#{LABELS.fetch(group)} #{number}</a>)
        end
        "<p>#{escaped}</p>"
      end.join("\n")
      %(<aside class="comparatif-annotation" aria-label="#{CGI.escapeHTML(label)}"><p class="comparatif-note-title"><strong>#{CGI.escapeHTML(label)}</strong></p>#{paragraphs}</aside>)
    end

    def original_html(markdown, converter, index)
      # Seule la hiérarchie visuelle des titres est adaptée à la page comparative.
      markdown = markdown.gsub(/^(#+) /) { '#' * [Regexp.last_match(1).length + 1, 6].min + ' ' }
      # Les titres reçoivent des identifiants distincts, même pour « Invités » répété.
      counter = 0
      markdown = markdown.lines.map do |line|
        if line.start_with?('#')
          counter += 1
          line.rstrip + " {#comparatif-section-#{index}-#{counter}}\n"
        else
          line
        end
      end.join
      "<div class=\"comparatif-original\">\n#{converter.convert(markdown)}\n</div>"
    end

    def comparison_row(markdown, notes, label, index, converter, baseurl, sources, row_id)
      %(<section class="comparatif-row" id="#{row_id}" aria-label="#{CGI.escapeHTML(label)}">) +
        '<div class="comparatif-column comparatif-initial"><p class="comparatif-column-label">Texte initial</p>' +
        original_html(markdown, converter, index) + '</div>' +
        '<div class="comparatif-column comparatif-changes"><p class="comparatif-column-label">Changements proposés</p>' +
        annotation(notes, label, baseurl, sources) + '</div></section>'
    end

    def generate(site)
      root = site.source
      data = JSON.parse(File.read(File.join(root, 'textes/comparatif.json'), encoding: 'bom|utf-8'))
      original = File.read(File.join(root, 'textes/archives/constitution.md'), encoding: 'bom|utf-8')
                     .sub(/\A---\r?\n.*?\r?\n---\r?\n/m, '')
      sources = FILES.transform_values do |filename|
        File.read(File.join(root, "textes/#{filename}.md"), encoding: 'bom|utf-8')
      end
      markers = original.to_enum(:scan, /<a id="article-(\d+)"><\/a>/).map { Regexp.last_match.dup }
      unless markers.map { |match| match[1].to_i } == (1..116).to_a && data.fetch('articles').keys.map(&:to_i).sort == (1..116).to_a
        raise 'Comparatif incomplet : les 116 articles et leurs annotations sont requis'
      end
      converter = site.find_converter_instance(Jekyll::Converters::Markdown)
      version = CGI.escapeHTML(data.fetch('version_comparee'))
      body = ['<p>Pour chaque article, le texte initial est présenté à côté des changements proposés, dans une zone bleue distincte. Sur téléphone, les changements suivent le texte initial. Les annotations décrivent les modifications, omissions et déplacements, sans en donner les motifs.</p>',
              '<p>« Non repris » signifie non reproduit explicitement dans le projet. Les renvois aux politiques extérieures ne sont pas une vérification de leur contenu.</p>',
              %(<p><a href="#{CGI.escapeHTML(site.baseurl + '/' + PDF)}" download>Télécharger le comparatif en PDF</a> · <a href="#{CGI.escapeHTML(site.baseurl)}/constitution.html">Consulter le texte initial sans annotations</a></p>)]
      articles = (1..116).map { |n| %(<a href="#comparatif-article-#{n}">#{n}</a>) }.join(' ')
      body << %(<details class="comparatif-acces"><summary>Accéder à un article initial</summary><nav aria-label="Articles de la constitution initiale">#{articles}</nav></details>)
      prefix = original[0...markers.first.begin(0)]
      split = prefix.rindex("\n## ") || prefix.length
      body << comparison_row(prefix[0...split], data.fetch('preliminaires'), 'Annotation — Préliminaires', 0,
                             converter, site.baseurl, sources, 'comparatif-preliminaires')
      body << original_html(prefix[split..], converter, 1)
      markers.each_with_index do |match, i|
        ending = i + 1 < markers.length ? markers[i + 1].begin(0) : original.length
        piece = original[match.begin(0)...ending]
        split = piece.index("\n## ") || piece.length
        body << comparison_row(piece[0...split], data.fetch('articles').fetch(match[1]), "Annotation — Article #{match[1]}",
                               i * 2 + 2, converter, site.baseurl, sources, "comparatif-article-#{match[1]}")
        body << original_html(piece[split..], converter, i * 2 + 3) if split < piece.length
      end
      body << '<h2 id="comparatif-ajouts">Dispositions ajoutées ou développées</h2>'
      body << '<div class="comparatif-column comparatif-changes">'
      body << annotation(data.fetch('ajouts'), 'Ajouts dans le projet', site.baseurl, sources)
      body << '</div>'
      page = Jekyll::PageWithoutAFile.new(site, site.source, '', 'comparatif.html')
      page.content = body.join("\n")
      page.data.merge!('layout' => 'default', 'title' => 'Comparatif avec la constitution initiale',
                       'document_label' => 'Comparatif — version 0.13', 'comparison_version' => "Version #{data.fetch('version_comparee')}",
                       'permalink' => '/comparatif.html')
      site.pages << page
      raise 'PDF du comparatif absent' unless File.file?(File.join(root, 'site', PDF))
    end
  end
end
