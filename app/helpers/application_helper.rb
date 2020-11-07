module ApplicationHelper
  DISABLED_CONTROLLERS = %w(
    confirmations
    passwords
    registrations
    sessions
    unlocks
  )

  # Sets the page title
  def page_title(title, some_user=nil, model_name=nil)
    content_for :page_title do
      @page_title = ""
      if some_user
        if user_signed_in? && some_user.id == current_user.id
          @page_title = "Your "
        else
          @page_title = "#{some_user.full_name}'s "
        end
      end

      @page_title += model_name || title
    end
  end

  # Displays notice
  def display_notice
    if notice
      raw(
        %Q(<div id="notice" class="notice alert alert-success text-center">
        #{notice}</div>)
      )
    end
  end

  # Displays alert
  def display_alert
    if alert
      raw(
        %Q(<div id="alert" class="alert alert-danger text-center">
        #{alert}</div>)
      )
    end
  end

  # Conditional rendering
  def render_if(condition, record)
    if condition
      render record
    end
  end

  def render_left_bar?
    !DISABLED_CONTROLLERS.include?(controller.controller_name) ||
      (controller.controller_name == 'registrations' &&
      controller.action_name == 'edit')
  end
end
