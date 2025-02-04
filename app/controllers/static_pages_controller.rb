class StaticPagesController < ApplicationController
    skip_before_action :require_login, only: %i[top terms_of_service privacy_policy]
  
    def top
      @board = Board.first
      search_params = params[:q] || {}
      query_cont = search_params[:query_cont]

      @q = Board.ransack(camera_make_or_camera_model_cont: query_cont)

    if params[:camera_make].present?
      @q = @q.result(distinct: true).where(camera_make: params[:camera_make])
      if params[:camera_make] == "その他" && params[:custom_camera_make].present?
        @q = @q.result(distinct: true).where("custom_camera_make LIKE ?", "%#{params[:custom_camera_make]}%")
      end
    end

      @total_boards_count = @q.result(distinct: true).count
      @boards = @q.result(distinct: true).includes(:user, :camera).order(created_at: :desc).page(params[:page]).per(30)
    end

    def terms_of_service
    end
  
    def privacy_policy
    end
  end
  