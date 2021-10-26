exports.generateState =
    ({ appData, additionalData, props }) => (just) => (nothing) => ({
        branches: mapBranches(appData[0], just, nothing),
        filtered: nothing,
        cities: appData[1] ? mapCities(appData[1], just, nothing) : mapCities(additionalData.cities, just, nothing),
        props: props,
        alwaysOpen: false,
        activeCity: 1,
        company_id: additionalData.company_id ? just(additionalData.company_id) : nothing,
        activeBranch: nothing
    });

const mapCities = (cities, just, nothing) => cities.map(city => ({
    value: city.value,
    title: city.title ? city.title : city.label,
    disabled: city.disabled,
    companies: city.companies ? just(city.companies) : nothing,
    allowedPayments: city.allowedPayments ? just(city.allowedPayments) : nothing
}));

const mapBranches = (branches, just, nothing) => branches.map(branch => ({
    id: branch.id,
    byTags: branch.byTags,
    company_id: branch.company_id ? just(branch.company_id) : nothing,
    allowedPayments: branch.allowedPayments ? just(branch.allowedPayments) : nothing,
    location: branch.location
}));