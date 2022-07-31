const width = 900
const height = 600
const margin = {top: 10,    bottom: 40,    left: 50,     right: 10}

const svg = d3.select("#chart").append("svg").attr("id", "svg").attr("width", width).attr("height", height)
const elementGroup = svg.append("g").attr("id", "elementGroup").attr('transform', `translate(${50}, ${margin.top})`)
const axisGroup = svg.append("g").attr("id", "axisGroup")
const xAxisGroup = axisGroup.append("g").attr("id", "xAxisGroup").attr('transform', `translate(${margin.left},${height - margin.bottom})`)
const yAxisGroup = axisGroup.append("g").attr("id", "yAxisGroup").attr('transform', `translate(${margin.left},${margin.top})`)

const dateFormat = d3.timeParse("%Y")

const y = d3.scaleBand().range([0 , height - margin.top - margin.bottom]).paddingInner(0.2).paddingOuter(0.02)
const x = d3.scaleLinear().range([0, width - margin.left - margin.right])

const xAxis = d3.axisBottom().scale(x).ticks(5).tickSize(-width)
const yAxis = d3.axisLeft().scale(y)


d3.csv("data.csv").then(data => {
    data = d3.nest()
    .key(d => d.winner).sortKeys(d3.ascending)
    .entries(data)
    

    data.map(d => {
        d.title = d.values.length
        d.winner = d.key    
        d.year = + d.year
    })
    y.domain( data.map(d=> d.key))
    x.domain(d3.extent(data.map(d=> d.title)))
    console.log(data)
    xAxisGroup.call(xAxis)
    yAxisGroup.call(yAxis)
  
    let bars = elementGroup.selectAll("rect").data(data)
    bars.enter().append("rect")
    
        .attr("class", "bar")
        .attr("height", y.bandwidth())
        .attr("width",(d=> x(d.title) + margin.left - margin.right ))
        .attr("x",  [1 , d => x(d.title)])
        .attr("y", d => y(d.key))
        .attr("anchor", "middle") 

        
})
function slider() {    
    var sliderTime = d3
        .sliderBottom()
        .min(d3.min(years))  
        .max(d3.max(years))
        .step(4)  
        .width(580) 
        .ticks(90)  
        .default(2018) 
        .on('onchange', val => {
            d3.select("d => d.value").text(sliderTime.value());
            // conectar con la gráfica aquí
        });

        var gTime = d3
        .select('div#slider-time')  
        .append('svg')
        .attr('width', width * 0.8)
        .attr('height', 100)
        .append('g')
        .attr('transform', 'translate(30,30)');

        gTime.call(sliderTime);

        d3.select('p#value-time').text(sliderTime.value());
}