class SortParam
  attr_accessor :as_given, :root_class

  def initialize(params = {})
    @as_given = params[:as_given]
    @root_class = params[:root_class]
  end

  def to_activerecord_order_clause
    name, suffix = parse_sort_param(as_given)
    name = resolve_scope(name) if name.include?('.')
    name + suffix
  end

  protected

  def parse_sort_param(param)
    if param.starts_with?('-')
      name, suffix = [param[1..-1], ' DESC']
    else
      [param, '']
    end
  end

  # NOTE: edge case & gotcha here for the future, where
  # we have a double-join onto the same table as different
  # associations (e.g. stakeholder / recorded_by both join to people)
  def resolve_scope(name)
    association, field = name.split('.')
    table_name = to_table_name(association)
    [table_name, field].join('.')
  end

  def to_table_name(association)
    reflection = root_class.reflect_on_association(association)
    class_name = reflection.try(:options).try(:[], :class_name) || association
    class_name.classify.constantize.table_name
  end
end
