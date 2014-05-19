Given(/^I am viewing "\/"$/) do
  visit ("/")
end                                                                

Then(/^I should see "Resolver Service"$/) do
end

When(/^I click resolve$/) do
  click_button "resolve"
end
