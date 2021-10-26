"use strict";

const createMap = () => {
    const uluru = { lat: 41.9499431, lng: 44.7480655 };
    const mapElement = document.getElementById('map');
    const mapStyles = new Array(
        { 'featureType': 'all', 'elementType': 'labels.text.fill', 'stylers': [{ 'saturation': 36 }, { 'color': '#000000' }, { 'lightness': 40 }] },
        { 'featureType': 'all', 'elementType': 'labels.text.stroke', 'stylers': [{ 'visibility': 'on' }, { 'color': '#000000' }, { 'lightness': 16 }] },
        { 'featureType': 'all', 'elementType': 'labels.icon', 'stylers': [{ 'visibility': 'off' }] },
        { 'featureType': 'administrative', 'elementType': 'geometry.fill', 'stylers': [{ 'color': '#000000' }, { 'lightness': 20 }] },
        { 'featureType': 'administrative', 'elementType': 'geometry.stroke', 'stylers': [{ 'color': '#000000' }, { 'lightness': 17 }, { 'weight': 1.2 }] },
        { 'featureType': 'administrative', 'elementType': 'labels', 'stylers': [{ 'visibility': 'off' }] },
        { 'featureType': 'administrative.country', 'elementType': 'all', 'stylers': [{ 'visibility': 'simplified' }] },
        { 'featureType': 'administrative.country', 'elementType': 'geometry', 'stylers': [{ 'visibility': 'simplified' }] },
        { 'featureType': 'administrative.country', 'elementType': 'labels.text', 'stylers': [{ 'visibility': 'simplified' }] },
        { 'featureType': 'administrative.province', 'elementType': 'all', 'stylers': [{ 'visibility': 'off' }] },
        { 'featureType': 'administrative.locality', 'elementType': 'all', 'stylers': [{ 'visibility': 'simplified' }, { saturation: -100 }, { lightness: 30 }] },
        { 'featureType': 'administrative.neighborhood', 'elementType': 'all', 'stylers': [{ 'visibility': 'off' }] },
        { 'featureType': 'administrative.land_parcel', 'elementType': 'all', 'stylers': [{ 'visibility': 'off' }] },
        // { "featureType": "landscape", "elementType": "all", "stylers": [{ "visibility": "simplified" }, { "gamma": 0.00 }, { "lightness": 74 }] },
        // { "featureType": "landscape", "elementType": "geometry", "stylers": [{ "color": "#000000" }, { "lightness": 20 }] },
        // { "featureType": "landscape.man_made", "elementType": "all", "stylers": [{ "lightness": 3 }] },{
        {
            'featureType': 'landscape',
            'stylers': [
                {
                    'color': '#202830'
                }
            ]
        },
        { 'featureType': 'poi', 'elementType': 'all', 'stylers': [{ 'visibility': 'off' }] },
        { 'featureType': 'poi', 'elementType': 'geometry', 'stylers': [{ 'color': '#000000' }, { 'lightness': 21 }] },
        { 'featureType': 'road', 'elementType': 'geometry', 'stylers': [{ 'visibility': 'simplified' }] },
        { 'featureType': 'road.highway', 'elementType': 'geometry.fill', 'stylers': [{ 'color': '#000000' }, { 'lightness': 17 }] },
        { 'featureType': 'road.highway', 'elementType': 'geometry.stroke', 'stylers': [{ 'color': '#000000' }, { 'lightness': 29 }, { 'weight': 0.2 }] },
        { 'featureType': 'road.arterial', 'elementType': 'geometry', 'stylers': [{ 'color': '#000000' }, { 'lightness': 18 }] },
        { 'featureType': 'road.local', 'elementType': 'geometry', 'stylers': [{ 'color': '#000000' }, { 'lightness': 16 }] },
        { 'featureType': 'transit', 'elementType': 'geometry', 'stylers': [{ 'color': '#000000' }, { 'lightness': 19 }] },
        // { "featureType": "water", "elementType": "geometry", "stylers": [{ "color": "#000000" }, { "lightness": 17 }] }
        {
            'featureType': 'water',
            'stylers': [
                {
                    'color': '#323b43'
                }
            ]
        }
    );

    const mapOptions = {
        zoom: 16,
        center: uluru,
        styles: mapStyles
    };

    return new google.maps.Map(mapElement, mapOptions);
}

const markerIcons = {
    active: { url: 'https://newstatic.adjarabet.com/static/images/icons/pin-red.svg' },
    passive: { url: 'https://newstatic.adjarabet.com/static/images/icons/pin-white.svg' }
};

const toggleMarker = (map, marker, focus) => {

    if (marker['active']) {
        marker.setIcon(markerIcons.active);
        marker.set('active', false);
    } else {
        marker.setIcon(markerIcons.passive);
        marker.set('active', true);
    }

    focus ? focusMarker(map, marker) : map;
}

const focusMarker = (map, marker) => {
    map.setCenter(marker.getPosition());
    map.setZoom(15);

    return map;
}

exports.clearMarkers = (markers) => () => {
    markers.map((markerItem) => {
        markerItem.setMap(null);
    });
}

exports.initMap = () => new Promise(res => {
    const script = document.createElement('script');
    script.src = "https://maps.googleapis.com/maps/api/js?libraries=visualization,places,drawing&key=AIzaSyC-rij9Ksd5c0K4IuDYwF838Mr9oBt0RFY";
    script.async = true;
    script.defer = true;
    script.onload = (ev) => res({ script: script, map: createMap() });
    document.body.appendChild(script);
})

exports.drawMarkers = (branches) => (activeMarker) => (map) => (props) => {
    let bounds = new google.maps.LatLngBounds();

    let markers = branches.map((item) => {
        if (item.location) {
            const marker = new google.maps.Marker({
                position: item.location,
                map: map
            });

            marker.set('id', item.id);
            marker.setIcon(markerIcons.active);
            marker.set('key', item.id);

            if (branches.length > 1) bounds.extend(marker.getPosition());

            if (item.id == activeMarker.value0) toggleMarker(map, marker, true);

            google.maps.event.addListener(marker, 'click', () => {
                toggleMarker(map, marker, false);
            });
            return marker;
        }
    });

    if (branches.length > 1) {
        map.fitBounds(bounds);
    } else {
        markers.map((markerItem) => {
            toggleMarker(map, markerItem, markerItem['key'], true);
        });
    }

    return { map: map, markers: markers };
}

exports.destroy = (script) => () => {
    document.body.removeChild(script);

    let scripts = document.querySelectorAll("script[src*='maps.googleapis.com/maps-api-v3']");

    for (var i = 0; i < scripts.length; i++) {
        scripts[i].parentNode.removeChild(scripts[i]);
    }
}