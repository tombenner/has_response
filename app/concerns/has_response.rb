module HasResponse
  extend ActiveSupport::Concern

  def to_response_with(*attributes)
    raise "Class `#{self.class.name}' does not have a `to_response' method defined" and return nil if !respond_to?(:to_response)
    response = self.to_response
    attributes.each do |attribute|
      if attribute.is_a?(Hash)
        attribute.each do |key, value|
          response[format_response_key(key)] = format_response_value(self.send(key), value)
        end
      elsif attribute.is_a?(Array)
        attribute.each do |key|
          response[format_response_key(key)] = format_response_value(self.send(key))
        end
      elsif attribute.is_a?(Symbol)
        response[format_response_key(attribute)] = format_response_value(self.send(attribute))
      end
    end
    response
  end

  def format_response_key(key)
    key = key.to_s
    key.sub!(/\?$/, '')
    key.to_sym
  end

  def format_response_value(object, with=nil)
    if object.nil?
      nil
    elsif object.is_a?(TrueClass) || object.is_a?(FalseClass) || object.is_a?(String) || object.is_a?(String) || object.is_a?(Integer)
      object
    elsif object.is_a?(ActiveRecord::Relation) || object.is_a?(Array)
      object.collect do |record|
        with.nil? ? record.to_response : record.to_response_with(with)
      end
    else
      with.nil? ? object.to_response : object.to_response_with(with)
    end
  end
end