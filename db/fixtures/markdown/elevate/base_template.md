Dear {{ contact_name }},  
Elevate Energy has completed an Energy Assessment for your building. We inspected the property, analyzed past utility bills, and modeled potential energy upgrades. This report details our findings and recommendations. Elevate has helped hundreds of other buildings owners save&mdash;and now it's your turn.

The table below summarizes your current energy usage and potential for savings.

{% usage_summary gas, water %}

The next page outlines our specific recommendations for your property, cost and savings associated with each recommendation, and any utility rebates that may be applicable. The report also provides information on financing, health and safety recommendations, and an explanation of some of the non-efficiency benefits of the recommended improvements.

{% image elevate/progress-graphic.png %}

What happens next? Call us. We can answer any questions you have and continue the process. We'll help you every step of the way. The sooner you start, the sooner you can save.

Regards,<br>
{{ auditor_name }}

{% pagebreak %}

### Recommended Efficiency Improvements

The table below summarizes the most important upgrades we recommend for your building, based on our site visit and analysis of your utility bills. The estimated cost, savings, and payback period are calculated for each recommendation. Your expected reduction in usage is shown in therms for natural gas and gallons for water. The recommendations are ranked by savings-to-investment ratio (SIR), which indicates how many times an upgrade will pay for itself by the end of its lifetime. Upgrades with high SIRs make the most sense and should be done first.

{% recommendations_table %}

### Paying for Efficiency

You can pay for upgrades any way you like. There are no funding requirements for our services. What follows is information about rebates, financing, and water programs that can assist in offsetting the costs of implementing our recommendations.

#### Utility Rebates

The rebates shown in the table above are an estimate of the current incentives offered by the utility companies. They should give you an idea of the amount you may receive depending on your eligibility, timing, and actual scope of work. However, these rebates are subject to change. Your Energy Analyst will follow up with you to discuss your eligibility for these rebates and can help you apply for them.

#### Low-cost Energy Loans

Elevate Energy has a partnership with the Community Investment Corporation (CIC), a nonprofit lender, to finance energy-efficiency measures in multifamily buildings. CIC offers Energy Savers Loans at a fixed-rate of 3% (check with CIC for current rate) with a seven-year term as a second mortgage to pay for energy efficiency improvements.

To learn more about loan options, contact CIC's Energy Savers Program Manager:

<div style='text-align: center'>
Jack Crane<br>
(312) 870-9925<br>
jack.crane@cicchicago.com
</div>

#### Water Saving Programs

Due to rising water rates in and around the city, we understand that water bills are becoming a priority for many building owners. In some cases, both water and energy usage in a building can be reduced through the same upgrades. A substantial amount of water can also be conserved in buildings through proper maintenance of fixtures. For some buildings, it may be beneficial to initiate a combined upgrade and maintenance program. If you are interested in learning more about this opportunity, please let us know.

### Non-Efficiency Benefits

Research shows that making energy and water efficiency improvements to your building can bring benefits beyond lower utility bills. These benefits include reduced operations and maintenance costs, higher tenant comfort, lower tenant turnover, and less variable utility costs. We would be happy to discuss the non-energy benefits of our recommendations with you in greater detail.

### Health and Safety Recommendations

In addition to helping you make your building more efficient, Elevate Energy will work with you to improve the health and safety of your building. The table below gives our specific health and safety recommendations. Unlike our efficiency recommendations, these may or may not be cost-effective or save your building energy, but they are critical in keeping your tenants and employees healthy and safe. Some may also improve the living conditions in your building and increase tenant comfort.

{% contentblock health_and_safety %}

### Next Steps

Now that Elevate Energy has completed our analysis and determined what improvements are needed in your building, we are here to help you move forward. We can help you with the following:

- Developing a project plan
- Soliciting and reviewing bids from contractors
- Filling out utility rebate applications
- Scheduling installation work and performing quality control inspections

Once work is finished, we will track the performance of your improved building by reviewing utility bills. We will provide an annual performance report, including a tune-up if your building is underperforming.

Building address:  {{ building_name }}<br>
{{ building_address }}<br>
{{ building_city }}, {{ building_state }} {{ building_zip }}<br>

Number of stories: {{ num_stories }}<br>
Number of units:  {{ num_apartments }}<br>

Method of analysis: {% contentblock method_of_analysis %}

This energy assessment and potential savings report was prepared by Elevate
Energy. Elevate Energy is a nonprofit organization whose mission is to provide
economic and environmental benefits to households, building owners, and
communities through energy efficiency and conservation.
