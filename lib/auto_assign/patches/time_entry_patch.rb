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
    module TimeEntryPatch
      extend ActiveSupport::Concern

      prepended do
        after_create :assign_issue
      end

      def assign_issue
        return unless issue

        log "assign_issue triggered for TimeEntry ##{id}"

        # Only assign if nobody is assigned yet
        if issue.assigned_to.blank?
          issue.assigned_to = user
          log "Assigned Issue ##{issue.id} to #{user.id}"
        end

        # Only move status if still "New"
        if issue.status&.name == "New"
          in_progress = IssueStatus.find_by(name: "In Progress")
          if in_progress
            issue.status = in_progress
            log "Moved Issue ##{issue.id} to In Progress"
          end
        end

        if issue.changed?
          issue.save!
        else
          log "No changes needed for Issue ##{issue.id}"
        end
      end

      private

      def log(msg)
        Rails.logger.info "[AutoAssign] #{msg}"
      end
    end
  end
end