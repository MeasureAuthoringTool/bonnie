MONGO_DB = Mongoid.default_session

module QME
  module DatabaseAccess
    # Monkey patch in the connection for the application
    def get_db
      Mongoid.default_session
    end
  end
end

