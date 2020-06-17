import { writable } from 'svelte/store';

let fetched_users = [];
let fetched_projects = [];
let project_tags = []
let user_tags = []
let all_tags = []
let all_related = {}

function compare(a, b) {
    if (a.info.rank > b.info.rank) return -1;
    if (b.info.rank < a.info.rank) return 1;
    return 0;
}

async function fetch_data(){
    let response = await fetch(`${window.location.origin}/data`);
    let text = await response.text();
    let data = text;
    let obj = JSON.parse(data);
    for (var p of obj.projects) {
        p.name = p.info.name
    }
    return { projects: obj.projects.sort(compare), users: obj.people.filter(user =>user.ecosystem.memberships.includes('ambassador')||user.ecosystem.memberships.includes('employee')||user.ecosystem.memberships.includes('contributor')) };
}

fetch_data().then((data)=>{
    fetched_users = data['users']
    fetched_projects = data['projects']

    users.set(fetched_users)
    projects.set(fetched_projects)
    loading.set(false)

    var relations = {}

    data['projects'].map(function(p){
        p.ecosystem.categories.forEach(function(item){
            relations[p.name] = []
            if (! project_tags.includes(item)){
                project_tags.push(item)
            }

            if (!all_related[item])
                all_related[item] = []
            
            all_related[item].push(p)
        })
    })

    

    // prop is relation
    for (const prop in all_related) {
        var related_circles = all_related[prop]

        for(var circlename in relations){
            for (var c of related_circles){
                if (c.name == circlename)
                    continue;
                var idx = -1
                for (var i=0; i < relations[circlename].length; i++){
                    if(relations[circlename][i]['name'] == c.name)
                        idx = i
                }

                if (idx == -1)
                    relations[circlename].push({'name': c.name, 'relations': [prop]})
                else
                    relations[circlename][idx]['relations'].push(prop)
            }
        }
      }

    data['users'].map(function(u){
        u.ecosystem.memberships.forEach(function(item){
            if (! user_tags.includes(item)){
                user_tags.push(item)
            }
        })
    })

    user_tags.forEach(function(t){
        all_tags.push({"href": "#/community/tags/"+t, "name": t})
    })

    project_tags.forEach(function(t){
        all_tags.push({"href": "#/circles/tags/"+t, "name": t})
    })

    projectags.set(project_tags)
    usertags.set(user_tags)
    alltags.set(all_tags)
})

export const users = writable(fetched_users);
export const projects = writable(fetched_projects);
export let loading = writable(true)
export const projectags = writable(project_tags)
export const usertags = writable(user_tags)
export const alltags = writable(all_tags)
export const related = writable(relations)