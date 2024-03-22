Feature: Depreciation calculation

  @depreciation
  Scenario: Straight line depreciation without salvage value
    Background:
      Given a setup
        And an item with entry value 100
    When start depreciation with salvage value 0, useful life 10
      Then create depreciation details
    When calculate depreciation
      Then create 0 depreciation entry
        And have book value 100
    When travel 1 year
      And calculate depreciation
        Then create 1 depreciation entry
          And last depreciation has accumulated depreciation 10, book value 90 and depreciation expense 10
          And have book value 90
    When travel 9 year
      And calculate depreciation
        Then create 9 depreciation entry
          And last depreciation has accumulated depreciation 100, book value 0 and depreciation expense 10
          And have book value 0

  @depreciation
  Scenario: Straight line depreciation with salvage value
    Background:
      Given a setup
        And an item with entry value 100
    When start depreciation with salvage value 50, useful life 10
      Then create depreciation details
    When calculate depreciation
      Then create 0 depreciation entry
        And have book value 100
    When travel 1 year
      And calculate depreciation
        Then create 1 depreciation entry
          And last depreciation has accumulated depreciation 5, book value 95 and depreciation expense 5
          And have book value 95
    When travel 9 year
      And calculate depreciation
        Then create 9 depreciation entry
          And last depreciation has accumulated depreciation 50, book value 50 and depreciation expense 5
          And have book value 50

  @depreciation
  Scenario: Stop adding new depreciation entries at period end
    Background:
      Given a setup
        And an item with entry value 100
    When start depreciation with salvage value 0, useful life 2
      Then create depreciation details
    When calculate depreciation
      Then create 0 depreciation entry
        And have book value 100
    When travel 1 year
      And calculate depreciation
        Then create 1 depreciation entry
          And have book value 50
    When travel 1 year
      And calculate depreciation
        Then create 1 depreciation entry
          And have book value 0
    When travel 1 year
      And calculate depreciation
        Then create 0 depreciation entry
          And have book value 0
