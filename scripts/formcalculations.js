/*
This source is shared under the terms of LGPL 3
www.gnu.org/licenses/lgpl.html

You are free to use the code in Commercial or non-commercial projects
*/



//Set up an associative array
//The keys represent the size of the cake
//The values represent the cost of the cake i.e A 10" cake cost's $35
var gender_coe = new Array();
gender_coe["male"]=3.8;
gender_coe["female"]=0;

var age_coe = new Array();
age_coe["below"]=0;
age_coe["above"]=3.0;

var college_coe = new Array();
college_coe["college_yes"]=-5.5;
college_coe["college_no"]=0;

var religion_coe = new Array();
religion_coe["religion_yes"]=-4.1;
religion_coe["religion_no"]=0;

var married_coe = new Array();
married_coe["married_yes"]=-0.5;
married_coe["married_no"]=0;

var migration_coe = new Array();
migration_coe["migration_yes"]=5.3;
migration_coe["migration_no"]=0;

var city_coe = new Array();
city_coe["city_yes"]=0;
city_coe["city_no"]=-0.1;

var income_coe = new Array();
income_coe["top"]=-1.0;
income_coe["bottom"]=0;

//NOTE: taking two parameters instead of one here is inefficient as I could
//      theoretically generate one from the other, but this was faster for me to do
	 
// getCakeSizePrice() finds the price based on the size of the cake.
// Here, we need to take user's the selection from radio button selection
function getCakeSizePrice(cha, coe)
{  
    var cakeSizePrice=0;
    //Get a reference to the form id="cakeform"
    var theForm = document.forms["cakeform"];
    //Get a reference to the cake the user Chooses name=selectedCake":
    var selectedCake = theForm.elements[cha];
    //Here since there are 4 radio buttons selectedCake.length = 4
    //We loop through each radio buttons
    for(var i = 0; i < selectedCake.length; i++)
    {
        //if the radio button is checked
        if(selectedCake[i].checked)
        {
            //we set cakeSizePrice to the value of the selected radio button
            //i.e. if the user choose the 8" cake we set it to 25
            //by using the cake_prices array
            //We get the selected Items value
            //For example cake_prices["Round8".value]"
            cakeSizePrice = coe[selectedCake[i].value];
            //If we get a match then we break out of this loop
            //No reason to continue if we get a match
            break;
        }
    }
    //We return the cakeSizePrice
    return cakeSizePrice;
}

// probabiity below 0 doesn't exist, show zero in that case
function showZeroIfNegative(x)
{
    if(x<0)
    {
        x = 0;
    }
    return x;
}


var f = d3.format(".1f");


function calculateTotal()
{
    //Here we get the total price by calling our function
    //Each function returns a number so by calling them we add the values they return together
    
    // summing the coefficients if dummy is 1; also adding intercept
    var cakePrice_raw = getCakeSizePrice("gender", gender_coe) 
                    + getCakeSizePrice("age", age_coe) 
                    + getCakeSizePrice("college", college_coe)
                    + getCakeSizePrice("religion", religion_coe)
                    + getCakeSizePrice("married", married_coe)
                    + getCakeSizePrice("migration", migration_coe)
                    + getCakeSizePrice("city", city_coe)
                    + getCakeSizePrice("income", income_coe)
                    + 5.9
                    ;

    var cakePrice = showZeroIfNegative(cakePrice_raw)
    
    //display the result
    var divobj = document.getElementById('totalPriceFooter');
    divobj.style.display='block';
    divobj.innerHTML = "The likelihood of a voter like you reporting to vote for the AfD is <br/> <span style='font-size: 20px'> <span style='background-color: red'>" + d3.format(".1f")(cakePrice) + "%. </span> </span>";



}

function hideTotal()
{
    var divobj = document.getElementById('totalPriceFooter');
    divobj.style.display='none';
}
