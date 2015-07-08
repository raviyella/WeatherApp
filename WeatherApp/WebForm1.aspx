<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WeatherApp.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Weather Application</title>

    <script type="text/javascript" lang="en">
        <%--src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js">--%>

        var Geo = {};
        function ValidateCity(form) {
            var city, error = '';
            city = document.getElementById('txtTemp').value;
            var regex = /^[a-zA-Z]+$/;

            if (!city.match(regex)) {
                error += 'Enter Valid City name\n';
            }

            if (error) {
                alert(error);
                return false;
            }

            if (navigator.geolocation)
            {
                navigator.geolocation.getCurrentPosition(WUnderGroundAPI, error);
                navigator.geolocation.getCurrentPosition(OpenWeatherMapAPI, error);
            }
            else
            {
                alert('Geolocation is not supported');
            }

            return true;
        }

        function Average()
        {
            
                var temp1 = parseFloat(document.getElementById("txtWUText").value);
                var temp2 = parseFloat(document.getElementById("txtOWText").value);
                var result = (temp1 + temp2) / 2;
                document.getElementById("lblAverage").innerHTML = result;       
        }

        function WUnderGroundAPI(position) {
            Geo.lat = position.coords.latitude;
            Geo.lng = position.coords.longitude;

            var key = '1258f9ccbecc5dcc';
            var Weather = 'http://api.wunderground.com/api/' + key + '/forecast/geolookup/conditions/q/' + Geo.lat + "," + Geo.lng + ".json";

                    $.ajax({
            url: Weather,
            dataType: "jsonp",
            success: function (data) {
                var location = data['location']['city'];
                var temp = data['current_observation']['temp_c'];
                var img = data['current_observation']['icon_url'];
                var desc = data['current_observation']['weather'];
                var wind = data['current_observation']['wind_string'];

                document.getElementById('txtWUText').value = temp;
            }
        });

        }

        function OpenWeatherMapAPI(position) {
            Geo.lat = position.coords.latitude;
            Geo.lng = position.coords.longitude;
            
            var WeatherAPI = 'http://api.openweathermap.org/data/2.5/forecast?lat=' + Geo.lat +
                        '&lon=' + Geo.lng + '&callback=?'

            $.ajax({
                url: WeatherAPI,
                type: 'GET',
                dataType: "jsonp",
                success: function (data) {
                    var maintemp = data.list[0].main.temp;
                    temp = maintemp - 273.15; //converting to degree
                    document.getElementById('txtOWText').value = temp.toFixed(2);
                }
            });

           
        }

        function error() {
            alert("That's weird! We couldn't find you!");
        }


</script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <h1>How is the Weather like in ? <span id="location"> </span></h1>
        Enter City
        <input type="text" id="txtTemp" name="Temp" size="30" />
        <input type="button" value ="Check" id="btnCheck" onclick="return ValidateCity();" />
    </div>
        <div>
            <h3>Weather Underground Website<span id="Span1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; OpenWeatherMap Website</span></h3>
            <input type="text" id ="txtWUText" />&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
            <input type="text" id ="txtOWText" /></div>
    <script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
        <p>
            <asp:Label ID="Label1" runat="server" Text="Average is:"></asp:Label>
            <asp:Label ID="lblAverage" runat="server" Text=""></asp:Label>
            &nbsp;<input type="button" value ="Average" id="btnAvergae" onclick="Average();" /></p>
    </form>
    </body>
</html>
