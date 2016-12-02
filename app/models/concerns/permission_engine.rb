module PermissionEngine
  extend ActiveSupport::Concern

  def can(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      add_all_actions(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
      end
    end
  end

  def can?(controller, action, resource = nil)
    allowed = @allowed_actions[[controller.to_s, action.to_s]]
    allowed && (allowed == true || resource && allowed.call(resource))
  end

  private
  def add_all_actions(actions)
    actions = add_relevant_actions(actions)
    add_alias_actions(actions)
  end

  def add_relevant_actions(actions)
    relevant_actions.each do |required_actions|
      Array(actions).each do |action|
        return Array([*actions, *required_actions]).uniq if action.in?(required_actions)
      end
    end
    Array(actions)
  end

  def add_alias_actions(actions)
    Array(actions).map do |action|
      if actions_aliases.key?(action)
        actions_aliases[action]
      else
        action
      end
    end.flatten
  end

  def relevant_actions
    [
      [:new,  :create],
      [:edit, :update]
    ]
  end

  def actions_aliases
    {
      manage: [:index, :show, :new, :create, :edit, :update, :destroy],
      read:   [:index, :show]
    }
  end
end
