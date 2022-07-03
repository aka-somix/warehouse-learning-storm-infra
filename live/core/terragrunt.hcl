include {
  path   = find_in_parent_folders()
}

locals{
  globals = yamldecode(file(find_in_parent_folders("globals.yml")))
}

inputs = {
  # project configuration variables
  account_id              = get_aws_account_id()
  project_name            = local.globals.project_name
  region                  = local.globals.region
}
