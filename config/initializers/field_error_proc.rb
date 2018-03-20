# frozen_string_literal: true

ActionView::Base.field_error_proc = ->(tag, _) { tag }
