// This java script runs the quiz.

/*
This source is shared under the terms of LGPL 3
www.gnu.org/licenses/lgpl.html

You are free to use the code in Commercial or non-commercial projects
*/

//Set up an associative array, the keys represent the dummy category names, 
//the values the estimated coefficients
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
	 
// getCoefficientValue() finds the coefficient value based on the dummy category of the cake.
// Here, we need to take user's the selection from radio button selection
function getCoefficientValue(cha, coe)
{  
    var coefficientValue=0;
    //Get a reference to the form id="cakeform"
    var theForm = document.forms["cakeform"];
    //Get a reference to the category the user Chooses name=selectedDummyCategory":
    var selectedDummyCategory = theForm.elements[cha];
    //Here since there are 4 radio buttons selectedDummyCategory.length = 4
    //We loop through each radio buttons
    for(var i = 0; i < selectedDummyCategory.length; i++)
    {
        //if the radio button is checked
        if(selectedDummyCategory[i].checked)
        {
            //we set coefficientValue to the value of the selected radio button
            //by using the cake_prices array
            //We get the selected Items value
            coefficientValue = coe[selectedDummyCategory[i].value];
            //If we get a match then we break out of this loop
            //No reason to continue if we get a match
            break;
        }
    }
    //We return the coefficientValue
    return coefficientValue;
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
    var totalProb_raw = getCoefficientValue("gender", gender_coe) 
                    + getCoefficientValue("age", age_coe) 
                    + getCoefficientValue("college", college_coe)
                    + getCoefficientValue("religion", religion_coe)
                    + getCoefficientValue("married", married_coe)
                    + getCoefficientValue("migration", migration_coe)
                    + getCoefficientValue("city", city_coe)
                    + getCoefficientValue("income", income_coe)
                    + 5.9
                    ;

    var totalProb = showZeroIfNegative(totalProb_raw)
    
    //display the result
    var divobj = document.getElementById('totalPriceFooter');
    divobj.style.display='block';
    divobj.innerHTML = "The likelihood of a voter like you reporting to vote for the AfD is <br/> <span style='font-size: 20px'> <span style='background-color: red'>" + d3.format(".1f")(totalProb) + "%. </span> </span>";



}

function hideTotal()
{
    var divobj = document.getElementById('totalPriceFooter');
    divobj.style.display='none';
}
