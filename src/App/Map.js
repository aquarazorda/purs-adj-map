"use strict";

const createMap = (branches) => {
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

    return drawMarkers(branches, new google.maps.Map(mapElement, mapOptions));
}

const drawMarkers = (branches, map) => {
        let bounds = new google.maps.LatLngBounds();

        branches.forEach((item) => {
            if (item.location) {
                const marker = new google.maps.Marker({
                    position: item.location,
                    map: map
                });

                marker.set('id', item.id);
                // marker.setIcon(this.markerIcons.active);
                marker.set('key', item.id);

                if (branches.length > 1) bounds.extend(marker.getPosition());

                // google.maps.event.addListener(marker, 'click', () => {
                //     this.toggleMarker(marker, item.ngClass[0].key, false);
                // });

            }
        });

        if (branches.length > 1) {
            map.fitBounds(bounds);
        } else {
            this.markers.map((markerItem) => {
                // if (markerItem['id'] === this.activeMarkerId) this.toggleMarker(markerItem, markerItem['key'], true);
            });
        }
        return map;
}

exports.initMap = (branches) => () => new Promise(res => {
    const script = document.createElement('script');
    script.src = "https://maps.googleapis.com/maps/api/js?libraries=visualization,places,drawing";
    script.async = true;
    script.defer = true;
    script.onload = (ev) => res(createMap(branches));
    document.body.appendChild(script);
})

