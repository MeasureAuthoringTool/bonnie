class Numeric
  Alph = ("A".."Z").to_a
  def excel_column
    return "" if self < 1
    s, q = "", self
    loop do
      q, r = (q - 1).divmod(26)
      s.prepend(Alph[r])
      break if q.zero?
    end
    s
  end
end
