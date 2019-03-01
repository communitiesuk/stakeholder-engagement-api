module Api::V1::ApiHelper
  # JSON API spec defines sort param name & format
  # see https://jsonapi.org/format/#auto-id--sorting
  # Example: sort=name,-created_at
  # This function converts a string in the above format
  # to an array suitable for use in an activerecord order method,
  # in the above example that would be ['name', 'created_at DESC']
  def to_activerecord_order_clause(sort_param)
    if sort_param
      sort_param.to_s.split(',').map do |param|
        param.starts_with?('-') ? param[1..-1] + ' DESC' : param
      end
    end
  end

  # JSON API spec defines pagination very loosely
  # see https://jsonapi.org/format/#fetching-pagination
  # It specifies that the page query param should be used
  # along with some *suggestions* about sub-keys of it
  # So we will aim to support both suggested pagination strategies
  # 1. page[offset] & page[limit]
  # 2. page[number] & page[size]
  def to_offset(params)
    if page = params['page']
      if page['offset']
        page['offset'].to_i
      elsif page['number'] && page['size']
        # NOTE: page numbers usually start from 1!
        (page['number'].to_i - 1) * page['size'].to_i
      end
    end
  end

  def to_page_number(params, default_per_page: 20)
    if page = params['page']
      if page['number']
        # NOTE: page numbers usually start from 1!
        page['number'].to_i
      elsif page['offset']
        (page['offset'].to_i / (page['size'] || default_per_page).to_i) + 1
      end
    end
  end

  def to_limit(params, default: 20)
    if params['page']
      limit = params['page']['limit'] || params['page']['size'] || default
      limit.nil? ? nil : limit.to_i
    end
  end

  def paginate(scope, default_per_page = 20)
    page = to_page_number(params)
    per_page = to_limit(params, default: default_per_page)
    collection = scope.page(page).per(per_page)
  end

  def pagination_link(collection, page_number:)
    url_for(
      params.permit!.merge(
        only_path: true,
        page: {
          number: page_number,
          size: collection.limit_value
        }
      )
    )
  end

  def format_param(req = request)
    if req.format.json?
      :json
    elsif req.format.xml?
      :xml
    else
      :html
    end
  end

  def first_page_link(collection)
    pagination_link(collection, page_number: 1)
  end

  def last_page_link(collection)
    pagination_link(
      collection,
      page_number: collection.total_pages
    )
  end

  def previous_page_link(collection)
    pagination_link(
      collection,
      page_number: collection.current_page - 1
    ) unless collection.first_page?
  end

  def next_page_link(collection)
    pagination_link(
      collection,
      page_number: collection.current_page + 1
    ) unless collection.last_page?
  end

end
