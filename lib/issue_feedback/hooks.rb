module IssueFeedback
  class Hooks < Redmine::Hook::ViewListener
    def controller_issues_bulk_edit_before_save(context)
      reset_issue_feedback(context[:issue], context[:params])
    end

    def controller_issues_new_before_save(context)
      reset_issue_feedback(context[:issue], context[:params])
    end

    def controller_issues_edit_before_save(context)
      reset_issue_feedback(context[:issue], context[:params])
    end

    def reset_issue_feedback(issue, params, user = User.current)
      return if params[:skip_automatic_status_update] == '1'
      return if issue.status.name != 'Feedback'
      return unless issue.try(:current_journal).try(:attributes_before_change)
      return if issue.current_journal.attributes_before_change['status_id'] != issue.status.id
      return if issue.last_modifier_id == User.current.id

      tracker = Tracker.find_by_id(issue.tracker_id)
      in_progress = tracker.issue_statuses.find { |s| s.name == 'In Progress' }

      if in_progress.present?
        attrs = {:status_id => in_progress.id}
        issue.assign_attributes attrs, :without_protection => true
      end
    end
  end
  class ViewHooks < Redmine::Hook::ViewListener
    render_on :view_issues_edit_notes_bottom,
      :partial => 'issues/skip_automatic_status_update'
  end
end
