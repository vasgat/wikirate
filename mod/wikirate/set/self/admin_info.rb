format :json do
  view :migrations, perms: :none do
    %w[schema_migrations tranform_migrations].each_with_object({}) do |table, h|
      h[table] = migration_records table
    end.to_json
  end

  def migration_records table_name
    sql = "SELECT * FROM #{table_name}"
    ActiveRecord::Base.connection.execute(sql).each.each.map do |record|
      record[0]
    end
  end
end
