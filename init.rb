require 'redmine'

Redmine::Plugin.register :issue_feedback do
  name 'Redmine Issue Feedback'
  author 'Ricardo Santos'
  author_url 'https://github.com/thorin/'
  description 'Enables an issue to change from status "Feedback" to "In-progress" on update'
  url 'https://github.com/thorin/issue_feedback'
  version '1.0.0'
  requires_redmine :version_or_higher => '2.0.0'

  permission :skip_automatic_status_update, {}
end

RedmineApp::Application.config.after_initialize do
  require_dependency 'issue_feedback/infectors'
end

# hooks
require_dependency 'issue_feedback/hooks'
