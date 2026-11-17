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
    PDF = 'assets/documents/constitution-initiale-annotee-0.12.pdf'

    def annotation(notes, label, baseurl, sources)
      paragraphs = notes.map do |text|
        # Échapper le texte avant de transformer seulement les renvois déclarés.
        escaped = CGI.escapeHTML(text).gsub(/\[\[([A-Z0-9]+):(\d+\.\d+)\]\]/) do
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

    def generate(site)
      root = site.source
      data = JSON.parse(File.read(File.join(root, 'documentation/comparatif-0.12/annotations.json'), encoding: 'bom|utf-8'))
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
      body = ["<h1>Comparatif avec la constitution initiale</h1>",
              "<p>Comparaison avec le projet version #{version}.</p>",
              '<p>Le texte initial est conservé dans son ordre et sa numérotation. Les annotations en bleu indiquent les modifications, omissions et déplacements, avec des liens vers les paragraphes du projet. Elles ne donnent pas les motifs des changements.</p>',
              '<p>« Non repris » signifie non reproduit explicitement dans le projet. Les renvois aux politiques extérieures ne sont pas une vérification de leur contenu.</p>',
              %(<p><a href="#{CGI.escapeHTML(site.baseurl + '/' + PDF)}" download>Télécharger le comparatif en PDF</a> · <a href="#{CGI.escapeHTML(site.baseurl)}/constitution.html">Consulter le texte initial sans annotations</a></p>)]
      articles = (1..116).map { |n| %(<a href="#article-#{n}">#{n}</a>) }.join(' ')
      body << %(<details class="comparatif-acces"><summary>Accéder à un article initial</summary><nav aria-label="Articles de la constitution initiale">#{articles}</nav></details>)
      prefix = original[0...markers.first.begin(0)]
      split = prefix.rindex("\n## ") || prefix.length
      body << original_html(prefix[0...split], converter, 0)
      body << annotation(data.fetch('preliminaires'), 'Annotation — Préliminaires', site.baseurl, sources)
      body << original_html(prefix[split..], converter, 1)
      markers.each_with_index do |match, i|
        ending = i + 1 < markers.length ? markers[i + 1].begin(0) : original.length
        piece = original[match.begin(0)...ending]
        split = piece.index("\n## ") || piece.length
        body << original_html(piece[0...split], converter, i * 2 + 2)
        body << annotation(data.fetch('articles').fetch(match[1]), "Annotation — Article #{match[1]}", site.baseurl, sources)
        body << original_html(piece[split..], converter, i * 2 + 3) if split < piece.length
      end
      body << '<h2 id="comparatif-ajouts">Dispositions ajoutées ou développées</h2>'
      body << annotation(data.fetch('ajouts'), 'Ajouts dans le projet', site.baseurl, sources)
      page = Jekyll::PageWithoutAFile.new(site, site.source, '', 'comparatif.html')
      page.content = body.join("\n")
      page.data.merge!('layout' => 'default', 'title' => 'Comparatif avec la constitution initiale',
                       'document_label' => 'Comparatif — version 0.12', 'permalink' => '/comparatif.html')
      site.pages << page
      raise 'PDF du comparatif absent' unless File.file?(File.join(root, 'site', PDF))
    end
  end
end
