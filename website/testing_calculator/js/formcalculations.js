/*
This source is shared under the terms of LGPL 3
www.gnu.org/licenses/lgpl.html

You are free to use the code in Commercial or non-commercial projects
*/

 //Set up an associative array
 //The keys represent the size of the cake
 //The values represent the cost of the cake i.e A 10" cake cost's $35
 var gender_coe = new Array();
 gender_coe["male"]=20;
 gender_coe["female"]=25;

 var age_coe = new Array();
 age_coe["below"]=-3;
 age_coe["above"]=3;

 var college_coe = new Array();
 college_coe["college_yes"]=-5.5;
 college_coe["college_no"]=5.5;
 
 var religion_coe = new Array();
 religion_coe["religion_yes"]=-3.5;
 religion_coe["religion_no"]=3.5;
 
 var married_coe = new Array();
 married_coe["married_yes"]=-1.5;
 married_coe["married_no"]=3.5;

 var migration_coe = new Array();
 migration_coe["migration_yes"]=1.5;
 migration_coe["migration_no"]=3.5;

 var city_coe = new Array();
 city_coe["city_yes"]=1.5;
 city_coe["city_no"]=3.5;
 
 var income_coe = new Array();
 income_coe["top"]=1.5;
 income_coe["bottom"]=3.5;

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
      
function calculateTotal()
{
    //Here we get the total price by calling our function
    //Each function returns a number so by calling them we add the values they return together
    var cakePrice = getCakeSizePrice("gender", gender_coe) 
                    + getCakeSizePrice("age", age_coe) 
                    + getCakeSizePrice("college", college_coe)
                    + getCakeSizePrice("religion", religion_coe)
                    + getCakeSizePrice("married", married_coe)
                    + getCakeSizePrice("migration", migration_coe)
                    + getCakeSizePrice("city", city_coe)
                    + getCakeSizePrice("income", income_coe)


                    ;
    
    //display the result
    var divobj = document.getElementById('totalPrice');
    divobj.style.display='block';
    divobj.innerHTML = "Your chance of reporting to vote for the AfD is " +cakePrice + "%";

}

function hideTotal()
{
    var divobj = document.getElementById('totalPrice');
    divobj.style.display='none';
}