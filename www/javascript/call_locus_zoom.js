//To pick up changes to this you may need to clear cached files in the browser

function do_locuszoom_stuff(input_snp, input_chr, input_bp, input_formatsnp,population)
{

      var apiBase = "https://portaldev.sph.umich.edu/api/v1/";
      
      //console.log(document.getElementById("interactive_ref_link").href);
      
      //get the href value from the link created in ui.R
      full_interactive_ref_link = document.getElementById("interactive_ref_link").href;
      //remove the specific file reference
      interactive_ref_link = full_interactive_ref_link.replace("rs114138760_locus.json", "")
      
      
      
      //var ourdata = interactive_ref_link+input_snp+"_locus.json/"
      var ourdata = interactive_ref_link+input_snp+"_locus.json?"
      //var ourdata = "https://pdgenetics.shinyapps.io/GWASBrowser/_w_619d378c/interactive_stats/"+input_snp+"_locus.json/"
      //var ourdata = "http://127.0.0.1:6415//interactive_stats/"+input_snp+"_locus.json/"//"http://127.0.0.1:5103/rs114138760_locus.json/" 

      var data_sources = new LocusZoom.DataSources()
        //.add("assoc", ["AssociationLZ", {url:apiBase + "statistic/single/", params: {source: 45, id_field: "variant"}}])
        .add("assoc", ["AssociationLZ", {url: ourdata, params: { analysis:3, id_field: "variant" }}])
        .add("ld", ["LDLZ2", { url: "https://portaldev.sph.umich.edu/ld/"}])//api/v1/pair/LD/"}])
        .add("gene", ["GeneLZ", { url: apiBase + "annotation/genes/" }])
        .add("recomb", ["RecombLZ", { url: apiBase + "annotation/recomb/results/" }])
        .add("constraint", ["GeneConstraintLZ", { url: "https://gnomad.broadinstitute.org/api", params: { build: 'GRCh37' } }]);
        
        

      var layout = LocusZoom.Layouts.get("plot", "standard_association", { max_region_scale:2000000, state: { genome_build: 'GRCh37',ld_pop:population, chr:input_chr, start: input_bp-1000000, end: input_bp+1000000, ldrefvar: input_formatsnp}});


      window.plot = LocusZoom.populate("#lz-plot", data_sources, layout);

      
}
