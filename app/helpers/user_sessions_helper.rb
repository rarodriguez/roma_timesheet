module UserSessionsHelper
  def subtitle
    flash[:notice].nil? || flash[:notice] == "" ? "Please type your authentication information" : flash[:notice]
  end
end
