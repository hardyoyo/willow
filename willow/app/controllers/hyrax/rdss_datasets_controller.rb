# Generated via
#  `rails generate hyrax:work RdssDataset`

module Hyrax
  class RdssDatasetsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    # Adds Hyrax work notifications to the controller
    include Hyrax::Notifications::Notifiers
    self.curation_concern_type = ::RdssDataset

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::RdssDatasetPresenter
  end
end
