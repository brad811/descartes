require 'sequel'
require 'securerandom'
require 'json'

db = ENV['DATABASE_URL'] || 'mysql://localhost/descartes'

DB = Sequel.connect(db)
DB.extension :pagination

$LOAD_PATH.unshift File.dirname(__FILE__)
require 'graphs'
require 'tags'
require 'dashboards'
require 'graph_dashboard_relations'
require 'gists'
require 'comments'
require 'metrics'
require 'users'

Sequel.extension :core_extensions

Sequel::Model.plugin :json_serializer
Graph.plugin :json_serializer
Dashboard.plugin :json_serializer
Tag.plugin :json_serializer
Gist.plugin :json_serializer
Comment.plugin :json_serializer
User.plugin :json_serializer
