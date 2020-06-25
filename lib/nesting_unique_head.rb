# Nested unique header generation
require 'middleman-core/renderers/redcarpet'

class NestingUniqueHeadCounter < Middleman::Renderers::MiddlemanRedcarpetHTML
  def initialize
    super
    @@headers_history = {} if !defined?(@@headers_history)
  end

  def header(text, header_level)
    # By default slate uses the next expression: friendly_text = text.gsub(/<[^>]*>/,"").parameterize
    # But I need more simple method. Thanks to:
    #   https://stackoverflow.com/questions/41306355/how-to-replace-the-characters-in-a-string
    #   http://www.consultant.ru/document/cons_doc_LAW_198429/c956ff01bf42465d7052431dec215b77d0404875/
    replacements = {
      'а' => 'a',   'А' => 'a',
      'б' => 'b',   'Б' => 'b',
      'в' => 'v',   'В' => 'v',
      'г' => 'g',   'Г' => 'g',
      'д' => 'd',   'Д' => 'd',
      'е' => 'e',   'Е' => 'e',
      'ё' => 'e',   'Ё' => 'e',
      'ж' => 'zh',  'Ж' => 'zh',
      'з' => 'z',   'З' => 'z',
      'и' => 'i',   'И' => 'i',
      'й' => 'i',   'Й' => 'i',
      'к' => 'k',   'К' => 'k',
      'л' => 'l',   'Л' => 'l',
      'м' => 'm',   'М' => 'm',
      'н' => 'n',   'Н' => 'n',
      'о' => 'o',   'О' => 'o',
      'п' => 'p',   'П' => 'p',
      'р' => 'r',   'Р' => 'r',
      'с' => 's',   'С' => 's',
      'т' => 't',   'Т' => 't',
      'у' => 'u',   'У' => 'u',
      'ф' => 'f',   'Ф' => 'f',
      'х' => 'kh',  'Х' => 'kh',
      'ц' => 'ts',  'Ц' => 'ts',
      'ч' => 'ch',  'Ч' => 'ch',
      'ш' => 'sh',  'Ш' => 'sh',
      'щ' => 'shch','Щ' => 'shch',
      'ъ' => 'ie',  'Ъ' => 'ie',
      'ы' => 'y',   'Ы' => 'y',
      'ь' => '',    'Ь' => '',
      'э' => 'e',   'Э' => 'e',
      'ю' => 'iu',  'Ю' => 'iu',
      'я' => 'ia',  'Я' => 'ia',
      ' ' => '-',   '_' => '-',
    }
    friendly_text = text.gsub(Regexp.union(replacements.keys),replacements).parameterize
    # Default: @@headers_history[header_level] = text.parameterize
    @@headers_history[header_level] = text.gsub(Regexp.union(replacements.keys),replacements).parameterize

    if header_level > 1
      for i in (header_level - 1).downto(1)
        friendly_text.prepend("#{@@headers_history[i]}-") if @@headers_history.key?(i)
      end
    end

    return "<h#{header_level} id='#{friendly_text}'>#{text}</h#{header_level}>"
  end
end
