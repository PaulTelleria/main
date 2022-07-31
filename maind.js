const width = 900
const height = 600
const margin = {top: 10,    bottom: 40,    left: 50,     right: 10}

const svg = d3.select("#chart").append("svg").attr("id", "svg").attr("width", width).attr("height", height)
const elementGroup = svg.append("g").attr("id", "elementGroup").attr('transform', `translate(${50}, ${margin.top})`)
const axisGroup = svg.append("g").attr("id", "axisGroup")
const xAxisGroup = axisGroup.append("g").attr("id", "xAxisGroup").attr('transform', `translate(${margin.left},${height - margin.bottom})`)
const yAxisGroup = axisGroup.append("g").attr("id", "yAxisGroup").attr('transform', `translate(${margin.left},${margin.top})`)


const y = d3.scaleBand().range([0 , height - margin.top - margin.bottom]).paddingInner(0.1).paddingOuter(0.02)
const x = d3.scaleLinear().range([0, width - margin.left - margin.right])

const xAxis = d3.axisBottom().scale(x).ticks(5).tickSize(-width)
const yAxis = d3.axisLeft().scale(y)


d3.csv("data.csv").then(data => {
    data = d3.nest()
        .key(d => d.winner).sortKeys(d3.ascending)
        .key(d => d.year)
        .entries(data)
    
    data.map(d => {
        d.title = + d.values.length
        d.winner = d.key    
        d.year = + d.values.values.year
        
    })
    y.domain( data.map(d=> d.key))
    x.domain(d3.extent(data.map(d=> d.title)))

    function updatechart(data){
        var elements = div.selectAll("").data(data)
        elements.call(updatePs)
        elements.call(exitPs)}

    function updatePs(selection){
        selection.attr("color", "blue")}

    function exitPs(setInterval(() => {}, interval); )

    xAxisGroup.call(xAxis)
    yAxisGroup.call(yAxis)
   
    console.log(data[0])
    
    let bars = elementGroup.selectAll("rect").data(data)
    bars.enter().append("rect")
        .attr("class", "bar")
        .attr("height", y.bandwidth())
        .attr("width",(d=> x(d.title) + margin.left - margin.right ))
        .attr("x",[0 , d => x(d.title)])
        .attr("y", d => y(d.key))
        .attr("anchor", "middle") 
    })
    
function slider() {    
    var sliderTime = d3
        .sliderBottom()
        .min(d3.min(data.values.key))  
        .max(d3.max(data.values.key))
        .step(4)  
        .width(580) 
        .tickFormat(d3.timeFormat('%Y'))
        .ticks(data.values.key.length)  
        .default(new Date(2022)) 
        .on('onchange', _val => {
                console.log(sliderTime.value())
                gTime.call(sliderTime);
                d3.select(data.values.key).text(sliderTime.value());
    })}
            
    var gTime = d3
        .select('div#slider-time')  
        .append('svg')
        .attr('width', width * 0.8)
        .attr('height', 100)
        .append('g')
        .attr('transform', 'translate(30,30)');