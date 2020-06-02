import { writable } from 'svelte/store';

let fetched_users = [];
let fetched_projects = [];
let fetched_ambassadors;
let project_tags = []
let user_tags = []
let all_tags = []



async function fetch_data(){
    let response = await fetch(`${window.location.origin}/data`);
    let text = await response.text();
    let data = text;
    let obj = JSON.parse(data);
    for (var p of obj.projects) {
        p.name = p.info.name
    }
    return { projects: obj.projects, users: obj.people.filter(user =>user.ecosystem.memberships.includes('ambassador')), ambassadors : obj.ambassadors};
}

fetch_data().then((data)=>{
    fetched_users = data['users']
    fetched_projects = data['projects']
    fetched_ambassadors = data['ambassadors']
    users.set(fetched_users)
    projects.set(fetched_projects)
    ambassadors.set(fetched_ambassadors)
    loading.set(false)

    data['projects'].map(function(p){
        p.ecosystem.categories.forEach(function(item){
            if (! project_tags.includes(item)){
                project_tags.push(item)
            }
        })
    })

    data['users'].map(function(u){
        u.ecosystem.memberships.forEach(function(item){
            if (! user_tags.includes(item)){
                user_tags.push(item)
            }
        })
    })

    user_tags.forEach(function(t){
        all_tags.push({"href": "#/people/tags/"+t, "name": t})
    })

    project_tags.forEach(function(t){
        all_tags.push({"href": "#/projects/tags/"+t, "name": t})
    })

    projectags.set(project_tags)
    usertags.set(user_tags)
    alltags.set(all_tags)
})

export const users = writable(fetched_users);
export const projects = writable(fetched_projects);
export const ambassadors = writable(fetched_ambassadors);

export let loading = writable(true)
export const projectags = writable(project_tags)
export const usertags = writable(user_tags)
export const alltags = writable(all_tags)