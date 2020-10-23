# frozen_string_literal: true

# Add access to reviews/ratings to the product model
module Spree::ProductDecorator
  def self.prepended(base)
    base.has_many :reviews
  end

  def stars
    avg_rating.try(:round) || 0
  end

  def recalculate_rating
    self[:reviews_count] = reviews.reload.approved.count
    self[:avg_rating] = if reviews_count > 0
                          reviews.approved.sum(:rating).to_f / reviews_count
                        else
                          0
                        end
    save
  end

  def public_reviews
    return reviews if Spree::Reviews::Config[:include_unapproved_reviews]

    reviews.approved
  end
end

Spree::Product.prepend Spree::ProductDecorator
