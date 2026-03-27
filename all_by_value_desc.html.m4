<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>immo_db report</title>
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.7/css/dataTables.dataTables.css">
    <link rel="stylesheet" href="index.css">
  </head>
  <body>
    <h5>Generated on: syscmd(date)</h5> 
    <h6><a href="https://github.com/philippegabriel/immo_db">repo on github</a></h6>
    <!-- your generated table goes here -->
    <table border="1" id="report" class="stripe">
<thead>
<TR><TH>Date Mutation</TH>
<TH>Nature Mutation</TH>
<TH>Valeur Foncière</TH>
<TH>Num. Voie</TH>
<TH>Type de Voie</TH>
<TH>Voie</TH>
<TH>Code Postal</TH>
<TH>Commune</TH>
<TH>Type Local</TH>
<TH>Surface réelle Batie</TH>
<TH>Nombre Pièces principales</TH>
<TH>Surface Terrain</TH>
</TR>
</thead>
<tbody>
    include(tableinclude)
</tbody>
    </table>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.30.1/moment.min.js"></script>
    <script src="https://cdn.datatables.net/2.3.7/js/dataTables.js"></script>
    <script>
      DataTable.datetime('dd/MM/yyyy');
      new DataTable('#report', {
        pageLength: 100
      });
    </script>
  </body>
</html>

