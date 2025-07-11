class PublicationsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  load_and_authorize_resource only: [:edit, :update]

  def index
    @publication = Publication.first_or_create
  end

  def edit
    @publication = Publication.first_or_create
  end

  def update
    @publication = Publication.first_or_create
    if @publication.update(publication_params)
      redirect_to publications_path(locale: I18n.locale), notice: t('publications.updated')
    else
      render :edit
    end
  end

  private

    def publication_params
      params.require(:publication).permit(:content)
    end
end
