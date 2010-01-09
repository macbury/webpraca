Feature: Browse jobs in categories
  In order to find interesting jobs
  As a user
  I can browse through job offers in categories
  
  Scenario: Categories
    Given a job titled "Google CEO" exists in category "IT"
    And a job titled "Senior Rails developer" exists in category "Programowanie"
    And I am on the homepage
    When I follow "IT" within ".categories"
    And I should see "Google CEO"
    And I should not see "Senior Rails Developer"
    When I follow "Programowanie" within ".categories"
    And I should see "Senior Rails Developer"
    And I should not see "Google CEO" 
    
