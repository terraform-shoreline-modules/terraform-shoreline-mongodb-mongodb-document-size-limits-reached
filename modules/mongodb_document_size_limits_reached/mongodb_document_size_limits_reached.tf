resource "shoreline_notebook" "mongodb_document_size_limits_reached" {
  name       = "mongodb_document_size_limits_reached"
  data       = file("${path.module}/data/mongodb_document_size_limits_reached.json")
  depends_on = [shoreline_action.invoke_update_mongo_limit]
}

resource "shoreline_file" "update_mongo_limit" {
  name             = "update_mongo_limit"
  input_file       = "${path.module}/data/update_mongo_limit.sh"
  md5              = filemd5("${path.module}/data/update_mongo_limit.sh")
  description      = "Increase the document size limit in MongoDB configuration."
  destination_path = "/tmp/update_mongo_limit.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_mongo_limit" {
  name        = "invoke_update_mongo_limit"
  description = "Increase the document size limit in MongoDB configuration."
  command     = "`chmod +x /tmp/update_mongo_limit.sh && /tmp/update_mongo_limit.sh`"
  params      = ["MONGODB_CONF_FILE","NEW_LIMIT","DATABASE_NAME"]
  file_deps   = ["update_mongo_limit"]
  enabled     = true
  depends_on  = [shoreline_file.update_mongo_limit]
}

