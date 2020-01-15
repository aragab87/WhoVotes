
var margin = {top: 80, right: 80, bottom: 30, left: 80},
    width = 660 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var formatPercent = d3.format(".0%");

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
    .ticks(5);

var tip = d3.tip()
  .attr('class', 'd3-tip')
  .offset([-10, 0])
  .html(function(d) {
    return "<strong> Holding all other characteristics constant, <BR/>  </strong> <span style='color:red'>" + d.text_description + "</span> <strong> <BR/> increases the chance of someone voting  <BR/> for a right-wing populist party by <BR/> </strong> <span style='color:red'>" + d.coefficient + "</span>";
  })

var svg = d3.select("body").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

svg.call(tip);

d3.csv("data-model.csv", type, function(error, data) {
  x.domain(data.map(function(d) { return d.factor; }));
  y.domain([0, d3.max(data, function(d) { return d.coefficient; })]);

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("coefficient");

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