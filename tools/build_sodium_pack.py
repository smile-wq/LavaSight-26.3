"""Build the standalone Minecraft 26.3 resource pack for Sodium 0.9.2."""

from pathlib import Path
from tempfile import TemporaryDirectory
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo


def main():
    project = Path(__file__).resolve().parents[1]
    output = project / "dist" / "LavaSight-26.3-Sodium.zip"
    files = {
        "pack.png": project / "pack/pack.png",
        "pack.mcmeta": project / "sodium/pack.mcmeta",
    }
    for source in (project / "pack", project / "vanilla-fog", project / "sodium"):
        for path in (source / "assets").rglob("*"):
            if path.is_file():
                name = path.relative_to(source).as_posix()
                if name in files:
                    raise ValueError(f"Duplicate resource {name}")
                files[name] = path

    output.parent.mkdir(exist_ok=True)
    with TemporaryDirectory(dir=output.parent) as staging:
        archive = Path(staging) / output.name
        with ZipFile(archive, "w") as pack:
            for name, path in sorted(files.items()):
                # Fixed metadata keeps identical assets byte-for-byte reproducible.
                entry = ZipInfo(name)
                entry.create_system = 3
                entry.external_attr = 0o100644 << 16
                pack.writestr(entry, path.read_bytes(), compress_type=ZIP_DEFLATED)
        archive.replace(output)


if __name__ == "__main__":
    main()
