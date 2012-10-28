module IssueFeedback
  class Hooks < Redmine::Hook::ViewListener
    def controller_issues_bulk_edit_before_save(context)
      reset_issue_feedback(context[:issue])
    end

    def controller_issues_new_before_save(context)
      reset_issue_feedback(context[:issue])
    end

    def controller_issues_edit_before_save(context)
      reset_issue_feedback(context[:issue])
    end

    def reset_issue_feedback(issue, user = User.current)
      return if issue.status.name != 'Feedback'
      return unless issue.attributes_before_change
      return if issue.attributes_before_change['status_id'] != issue.status.id

      tracker = Tracker.find_by_id(issue.tracker_id)
      Rails.logger.error "Tracker statuse #{tracker.issue_statuses}"
      in_progress = tracker.issue_statuses.find { |s| s.name == 'In Progress' }

      if in_progress.present?
        attrs = {:status_id => in_progress.id}
        issue.assign_attributes attrs, :without_protection => true
      end
    end
  end

end
