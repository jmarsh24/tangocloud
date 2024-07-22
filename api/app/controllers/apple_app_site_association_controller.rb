class AppleAppSiteAssociationController < ApplicationController
  skip_after_action :verify_authorized, :verify_policy_scoped
  skip_before_action :authenticate_user!

  def show
    file_content = {
      applinks: {
        apps: [],
        details: [
          {
            appID: "8DN6UL88PX.com.tangocloud.app",
            paths: ["/recordings/*"]
          }
        ]
      },
      activitycontinuation: {
        apps: ["8DN6UL88PX.com.tangocloud.app"]
      },
      webcredentials: {
        apps: ["8DN6UL88PX.com.tangocloud.app"]
      }
    }

    render json: file_content
  end
end
