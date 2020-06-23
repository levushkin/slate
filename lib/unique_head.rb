# Unique header generation
require 'middleman-core/renderers/redcarpet'
require 'digest'
class UniqueHeadCounter < Middleman::Renderers::MiddlemanRedcarpetHTML
  def initialize
    super
    @head_count = {}
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

    if friendly_text.strip.length == 0
      # Looks like parameterize removed the whole thing! It removes many unicode
      # characters like Chinese and Russian. To get a unique URL, let's just
      # URI escape the whole header
      friendly_text = Digest::SHA1.hexdigest(text)[0,10]
    end
    @head_count[friendly_text] ||= 0
    @head_count[friendly_text] += 1
    if @head_count[friendly_text] > 1
      friendly_text += "-#{@head_count[friendly_text]}"
    end
    return "<h#{header_level} id='#{friendly_text}'>#{text}</h#{header_level}>"
  end
end
