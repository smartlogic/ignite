class FixEncodedSpeakerContent < ActiveRecord::Migration
  def self.up
    remove_column :speakers, :html_text

    replacements = {
      "&ntilde;" => "ñ",
      "&amp;" => "&",
      "&ndash;" => "-",
      "&mdash;" => "—",
      "&ldquo;" => '"',
      "&rdquo;" => '"',
      "&quot;" => '"',
      "&apos;" => "'",
      "&lsquo;" => "'",
      "&rsquo;" => "'",
      "&lsaquo;" => "<",
      "&rsaquo;" => ">",
      "&gt;" => ">",
      "&hellip;" => "…",
      "&bull;" => "*",
      "&middot;" => "·",
      "&trade;" => "™",
      "&eacute;" => "é",
      "&reg;" => "®",
    }
    columns = %w(email name title bio description)
    replacements.each_pair do |pattern, replacement|
      set_clauses = columns.map do |col|
        %Q(#{col} = REPLACE(#{col}, "#{pattern}", #{quoted_replacement(replacement)}))
      end
      sql = %Q(UPDATE speakers SET #{set_clauses.join(', ')})
      run(sql)
    end
  end

  def self.down
    # eh
  end
  
  def self.run sql
    connection.execute(sql)
  end
  
  def self.quoted_replacement(str)
    str == "'" ? %Q("#{str}") : %Q('#{str}')
  end
end
