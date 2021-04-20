// <%text>

class Params {
    constructor() {
        this.out = $(params_result);
        this.clear();
    }

    // ===== Getters and Setters =================

    get generic() {
        return $('#params_generic').prop('checked');
    }

    get protons() {
        return $('#params_protons').prop('checked');
    }

    get atomnames() {
        return params_atomnames.value;
    }

    get name() {
        const pn = $(params_name);
        pn.removeClass('is-invalid');
        pn.removeClass('is-valid');
        let name = pn.val() || 'LIG';
        name = name.replace(/\W/g, '');
        if (name.length !== 3) {
            pn.addClass('is-invalid');
            throw 'Name is not 3 long.'
        } else {
            pn.addClass('is-valid');
        }
        pn.val(name);
        return name;
    }

    get title() {
        const pt = $(params_title);
        pt.removeClass('is-invalid');
        pt.removeClass('is-valid');
        let title = pt.val() || 'ligand';
        title = title.replace(/\s/g, '_');
        if (title.length === 0) {
            pt.addClass('is-invalid');
            throw 'No letters'
        } else {
            pt.addClass('is-valid');
        }
        pt.val(title);
        return title;
    }

    get smiles() {
        const ps = $(params_smiles);
        ps.removeClass('is-invalid');
        ps.removeClass('is-valid');
        let smiles = ps.val();
        smiles = smiles.trim();
        if (smiles.length === 0) {
            ps.addClass('is-invalid');
            throw 'No SMILES'
        } else {
            ps.addClass('is-valid');
        }
        ps.val(smiles);
        return smiles;
    }

    // ===== Button events =================

    calculate() {
        if (params_file.files.length !== 0) {
            this.calc_mol();
        } else if (params_pdb_file.files.length !== 0) {
            this.calc_smiles_pdb();
        } else {
            this.calc_smiles();
        }
    }

    demo() {
        $(params_smiles).val('c1ccccc1');
        $(params_name).val('LIG');
        $(params_title).val('benzene');
    }

    clear() {
        $(params_smiles).val('');
        $(params_name).val('LIG');
        $(params_title).val('ligand');
        $(params_result).hide();
        params_file.value = null;
        params_pdb_file.value = null;
    }

    calc_smiles () {
        $.post({
            url: "params/smiles", data: {
                smiles: this.smiles,
                name: this.name,
                title: this.title,
                generic: this.generic,
                atomnames: this.atomnames,
            }
        }).fail(xhr => this.show_error.call(this, xhr))
            .done(msg => this.show_results.call(this, msg));
    }

    async calc_smiles_pdb () {
        let f = params_pdb_file.files[0];
        const block = await f.text();
        const extension = f.name.split('\.').pop().toLowerCase();
        if ((extension !== 'pdb') && (extension !== 'ent'))
        {   params_pdb_file.classList.add("is-invalid");
            throw 'Shove your damn CIF file where the sun dont shine. You prat.'}
        $.post({
            url: "params/smiles_pdb", data: {
                smiles: params_pdb_smiles.value, //optional.
                block: block,
                name: this.name,
                title: this.title,
                generic: this.generic,
                atomnames: this.atomnames,
            }
        }).fail(xhr => this.show_error.call(this, xhr))
            .done(msg => this.show_results.call(this, msg));
    }

    async calc_mol () {
        let f = params_file.files[0];
        const block = await f.text();
        const extension = f.name.split('\.').pop().toLowerCase();

        $.post({
            url: "params/mol", data: {
                name: this.name,
                title: this.title,
                generic: this.generic,
                protons: this.protons,
                atomnames: this.atomnames,
                extension: extension,
                block: block
            }
        }).fail(xhr => this.show_error.call(this, xhr))
            .done(msg => this.show_results.call(this, msg));
    }

    // ===== Output =================

    show_results(msg) {
        this.out.show();
        let text = '';
        if (msg.error !== undefined) {
            text = `<div class="alert alert-danger w-100 py-3" role="alert">
                      An error occured parsing your request (${msg.error}).
                      Please check the fields are correct and try again.
                    </div>`;
        } else {
            const icon = '<i class="far fa-download"></i>';
            text = `
            <div class="col-12"><h4>Results</h4></div>
            <div class="col-12">Final SMILES: ${msg.smiles}</div>
            <div class="col-12 col-md-6">${msg.svg}</div>
            <div class="col-12 col-md-6">
                <i>Legend</i> Atom element colon atom index dot atom name
                Note that the atom index is not necessarily the internal coordinate order, wherein
                backbone atoms come first if amino acid and hydrogens last.
                For more about conversion see <a href="https://github.com/matteoferla/rdkit_to_params" target="_blank">
                 Rdkit-to-params repo <i class="fab fa-github"></i></a>
            </div>
            <div class="col-12 pt-3">${icon} <a href="data:text/plain;charset=utf-8,${encodeURIComponent(msg.params)}" target="_blank" download="${this.title}.params">download params</a></div>
            <div class="col-12">${icon} <a href="data:text/plain;charset=utf-8,${encodeURIComponent(msg.pdb)}" target="_blank" download="${this.title}.pdb">download PDB</a></div>
            <div class="col-12">${icon} <a href="data:text/plain;charset=utf-8,${encodeURIComponent(msg.rotamers)}" target="_blank" download="${this.title}.pdb">download rotamers (requires params editing)</a></div>
`;
        }
        this.out.html(text);
    }

    show_error(xhr) {
        this.out.show();
        const alert = (msg) => `<div class="alert alert-danger" role="alert"><span class="pycorpse"></span>${msg}</div>`;
        if (!!xhr.responseJSON) {
            this.out.html(alert(`Error ${xhr.status}: ${xhr.responseJSON.error}`));
        } else if (!!xhr.responseText) {
            this.out.html(alert(`Error ${xhr.status}: ${xhr.responseText}`));
        } else {
            this.out.html(alert(`Error ${xhr.status}: UNKNOWN ERROR`));
        }
    }

}

///////////// DOM

$(function () {
    window.params = new Params();

    $('#params_demo').click(() => window.params.demo());
    $('#params_clear').click(() => window.params.clear());
    $('#params_calculate').click(() => window.params.calculate());
});
// </%text>
