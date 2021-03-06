require 'rails_helper'

describe "As a user" do
  let(:role) { create(:registered_user) }
  describe "visits /orders" do
    it "can see all past orders" do
      user = create(:user)
      user.roles << role
      create(:order, user: user)
      item = create(:item, price: 5.00)
      items_with_quantity = [ {item => 2} ]
      order_1 = create(:order_with_items, user: user, items_with_quantity: items_with_quantity)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/orders'

      expect(page).to have_css(".order", count: 2)

      within("#order-#{order_1.id}") do
        expect(page).to have_content(order_1.id)
        expect(page).to have_content(order_1.status.capitalize)
        expect(page).to have_content(order_1.total_price)
      end
    end
  end
end
