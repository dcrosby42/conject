
module Ruice::Inflector #:nodoc:#
  # Ganked this from Inflector:
  def self.camelize(lower_case_and_underscored_word) 
    lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end
  # Ganked this from Inflector:
  def self.underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
  end
end
