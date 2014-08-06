require "event_sourcing"

module EventSourcing
  class Command
    private_class_method :new

    def self.define(*fields, &block)
      raise "Commands require an execution block" unless block_given?

      Class.new(self) do
        public_class_method :new
        attr_reader(*fields)

        define_method :initialize do |properties = {}|
          EventSourcing.require_keywords(fields, properties.keys)

          fields.each do |field|
            instance_variable_set("@#{field}", properties[field])
          end
        end

        define_method :execute do |*args|
          instance_exec(*args, &block)
        end
      end
    end
  end
end
