class ApplicationSerializer < ActiveModel::Serializer
  def meta
    {
      status: @status || "success",
      message: @message || ""
    }
  end

  def meta_key
    "result"
  end
end
