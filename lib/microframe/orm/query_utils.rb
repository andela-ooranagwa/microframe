module Microframe
  module ORM
    module QueryUtils
      def process_query(queryset)
        return unless queryset
        query = build_query(queryset)
        execute(query)
      end

      def execute(query)
        Connection.execute(query)
      end

      def process_select(queryhash)
        queryhash["SELECT"] ||= ["*"]
        "SELECT #{queryhash['SELECT'].join(', ')}"
      end

      def process_from(queryhash)
        queryhash["FROM"] ||= table_name
        "FROM #{queryhash['FROM']}"
      end

      def process_where(queryhash)
        return "" unless queryhash["WHERE"]
        "WHERE #{queryhash['WHERE'].join(' AND ')}"
      end

      def process_generic(name, queryhash)
        return "" unless queryhash[name]
        "#{name} #{queryhash[name]}"
      end

      def process_order(queryhash)
        process_generic("ORDER BY", queryhash)
      end

      def process_limit(queryhash)
        process_generic("LIMIT", queryhash)
      end

      def query_processes
        [
          :process_select,
          :process_from,
          :process_where,
          :process_order,
          :process_limit
        ]
      end

      def build_query(queryhash)
        query = []
        query_processes.each { |process| query << send(process, queryhash) }
        query.join(" ").strip
      end

      def parse_result_to_objects(result)
        hash_objects = []
        result.each do |hash|
          obj = @model.new
          hash.each do |key, val|
            if key.is_a? String
              obj.instance_variable_set("@#{key}", val)
            end
          end
          hash_objects << obj
        end
        hash_objects
      end
    end
  end
end
