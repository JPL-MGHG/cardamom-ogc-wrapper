import sys
import xarray as xr

# ---- configuration ----
KEEP_INDICES = [0, 2, 14, 55]
KEEP_VARS = ["FLUXES", "FLUX_NAMES", "FLUX_DESCRIPTIONS", "FLUX_UNITS"]
# ------------------------

def main(infile, outfile):
    # Open dataset
    ds = xr.open_dataset(infile, engine="netcdf4")

    # Keep only flux variables
    ds = ds[KEEP_VARS]

    # Subset Flux dimension
    ds = ds.isel(Flux=KEEP_INDICES)

    # Fix FLUXES attributes
    flux_var = ds["FLUXES"]
    old_attrs = flux_var.attrs.copy()

    # Keep only FLUX-* attributes corresponding to the kept indices
    kept_flux_attrs = [
        (k, v)
        for k, v in old_attrs.items()
        if k.startswith("FLUX-") and v in KEEP_INDICES
    ]
    # Sort by order of KEEP_INDICES
    kept_flux_attrs.sort(key=lambda kv: KEEP_INDICES.index(kv[1]))

    # Renumber to 0..N-1
    renumbered_attrs = {key: i for i, (key, _) in enumerate(kept_flux_attrs)}

    # Preserve non-FLUX-* attributes
    other_attrs = {k: v for k, v in old_attrs.items() if not k.startswith("FLUX-")}

    # Assign cleaned attributes
    flux_var.attrs = {**other_attrs, **renumbered_attrs}

    # Write to output
    ds.to_netcdf(outfile)
    print(f"Written reduced flux-only file: {outfile}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python subset_flux_only.py input.nc output.nc")
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])