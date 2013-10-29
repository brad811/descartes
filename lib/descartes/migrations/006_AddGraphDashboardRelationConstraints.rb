
Sequel.migration do
  up do
    alter_table(:graph_dashboard_relations) do
      add_unique_constraint ['graphs.id', 'dashboard.id']
    end
  end
end
