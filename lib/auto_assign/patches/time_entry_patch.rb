#The MIT License (MIT)
#
#Copyright (c) 2026 rick barrette
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module AutoAssign
  module Patches
    # When someone logs time on an issue:
    # - if nobody is assigned, assign the issue to them (if they can be assigned in that project)
    # - if the issue is still at its starting status, move it to the "in progress" status
    #   (only when the workflow allows that change for them)
    # The change is recorded in the issue's history under the person who logged the time.
    module TimeEntryPatch
      extend ActiveSupport::Concern

      prepended do
        # After the time entry is committed, so a problem updating the issue can never undo the
        # logged time, and so we never touch the issue object an issue edit form is still saving.
        after_commit :assign_issue, on: :create
      end

      def assign_issue
        return unless issue_id && user

        # A fresh copy, not the (possibly half-edited) issue this time entry was built with
        target = Issue.find_by(id: issue_id)
        return unless target

        target.init_journal(user, ::I18n.t(:text_auto_assign_journal_note))
        assign_to_time_logger(target)
        move_to_in_progress(target)

        unless target.changed?
          log "No changes needed for Issue ##{target.id}"
          return
        end

        if target.save
          log "Updated Issue ##{target.id} after time entry ##{id}"
        else
          log "Could not update Issue ##{target.id}: #{target.errors.full_messages.join(', ')}"
        end
      rescue StandardError => e
        # The time entry is already saved; an error page here would wrongly suggest it wasn't
        log "Could not update Issue ##{issue_id}: #{e.class}: #{e.message}"
      end

      private

      def assign_to_time_logger(target)
        return if target.assigned_to.present?

        if target.assignable_users.include?(user)
          target.assigned_to = user
          log "Assigning Issue ##{target.id} to user ##{user.id}"
        else
          log "Not assigning Issue ##{target.id}: user ##{user.id} can't be assigned in this project"
        end
      end

      def move_to_in_progress(target)
        from = AutoAssign.starting_status_for(target)
        to = AutoAssign.in_progress_status
        return unless from && to && target.status == from && from != to

        # Checked after assigning, since workflows can allow more transitions for the assignee
        if target.new_statuses_allowed_to(user).include?(to)
          target.status = to
          log "Moving Issue ##{target.id} to #{to.name}"
        else
          log "Not moving Issue ##{target.id} to #{to.name}: the workflow doesn't allow it for user ##{user.id}"
        end
      end

      def log(msg)
        Rails.logger.info "[AutoAssign] #{msg}"
      end
    end
  end
end
