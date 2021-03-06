var margin = {top: 40, right: 80, bottom: 120, left: 80},
    width = 660 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var formatPercent = d3.format(".0");

var x = d3.scale.ordinal()
    .rangeRoundBands([0, width], .1);

var y = d3.scale.linear()
    .range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .tickFormat(formatPercent)
    .ticks(5)

var tip = d3.tip()
  .attr('class', 'd3-tip')
  .offset([-10, 0])
  .html(function(d) {
    return "<h5> <span style='color:pink'>" + d.text_description + "</span>  <BR/> increases the chance of voting for <BR/> the AfD by <span style='color:pink'>" + d.coefficient_percent + "</span> percentage points </h5> ";
  })

var svg = d3.select("#bar-chart-container").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

svg.call(tip);

d3.csv("data-model.csv", type, function(error, data) {
  x.domain(data.map(function(d) { return d.factor; }));
  y.domain([0, d3.max(data, function(d) { return d.coefficient; })]);


svg.append("text")
    .attr("x", -margin.left)
    .attr("y", -25)
    .attr("fill", "currentColor")
    .attr("text-anchor", "start")
    .text("Increase in the chance of voting for the AfD");

svg.append("text")
    .attr("x", -margin.left)
    .attr("y", -10)
    .attr("fill", "currentColor")
    .attr("text-anchor", "start")
    .text("(in percentage points)");

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)
      .selectAll("text")  
          .style("text-anchor", "end")
          .attr("dx", "-.8em")
          .attr("dy", ".15em")
          .attr("transform", "rotate(-40)" );


  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(0)")
      .attr("y", 8)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("");

  svg.selectAll(".bar")
      .data(data)
    .enter().append("rect")
      .attr("class", "bar")
      .attr("x", function(d) { return x(d.factor); })
      .attr("width", x.rangeBand())
      .attr("y", function(d) { return y(d.coefficient); })
      .attr("height", function(d) { return height - y(d.coefficient); })
      .on('mouseover', tip.show)
      .on('mouseout', tip.hide)

});

function type(d) {
  d.coefficient = +d.coefficient;
  return d;
}
